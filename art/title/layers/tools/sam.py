import sys, json, numpy as np, torch
from PIL import Image
from transformers import SamModel, SamProcessor
src,out,spec=sys.argv[1],sys.argv[2],json.load(open(sys.argv[3]))
im=Image.open(src).convert('RGB'); W,H=im.size
M=SamModel.from_pretrained('facebook/sam-vit-large').eval(); P=SamProcessor.from_pretrained('facebook/sam-vit-large')
emb=None
inp=P(im,return_tensors='pt')
with torch.no_grad(): emb=M.get_image_embeddings(inp['pixel_values'])
for name,o in spec.items():
    x,y,w,h=o['box']; kw={'input_boxes':[[[x,y,x+w,y+h]]]}
    if o.get('pts'):
        kw={'input_boxes':[[[x,y,x+w,y+h]]],'input_points':[[o['pts']]],'input_labels':[[o.get('lab',[1]*len(o['pts']))]]}
    i2=P(im,return_tensors='pt',**kw)
    with torch.no_grad():
        r=M(image_embeddings=emb,input_boxes=i2.get('input_boxes'),input_points=i2.get('input_points'),input_labels=i2.get('input_labels'),multimask_output=True)
    ms=P.image_processor.post_process_masks(r.pred_masks,i2['original_sizes'],i2['reshaped_input_sizes'])[0][0]
    sc=r.iou_scores[0,0]; k=int(torch.argmax(sc)) if 'pick' not in o else o['pick']
    m=ms[k].numpy()
    np.save(f'{out}/s_{name}.npy',m)
    a=m[y:y+h,x:x+w,None].astype(float); crop=np.asarray(im)[y:y+h,x:x+w]
    Image.fromarray((crop*a+np.array([255,0,255])*(1-a)).astype(np.uint8)).save(f'{out}/sv_{name}.png')
    print(name,[round(float(s),3) for s in sc],k,int(m.sum()),flush=True)
