# 44.1kHz 單聲道 Vorbis q3（好音質）。由 pick_final.json（老闆選定）把候選合成一張 work_sheet.ogg，並輸出索引（之後轉成 game/outpost/work_sfx_idx.gd）
import json,subprocess,numpy as np,sys
sel=json.load(open(sys.argv[1])); cand=sys.argv[2]; out=sys.argv[3]; SR=44100; gap=np.zeros(int(0.08*SR),np.float32); parts=[]; idx={}; t=0.0
for ev in sel:
    x=np.frombuffer(subprocess.run(['ffmpeg','-v','error','-i',f'{cand}/{ev}_{sel[ev]}.ogg','-ac','1','-ar',str(SR),'-f','f32le','-'],capture_output=True).stdout,np.float32)
    idx[ev]=[round(t,4),round(len(x)/SR,4)]; parts+=[x,gap]; t+=(len(x)+len(gap))/SR
subprocess.run(['ffmpeg','-v','error','-y','-f','f32le','-ar',str(SR),'-ac','1','-i','-','-c:a','libvorbis','-q:a','3',out],input=np.concatenate(parts).tobytes(),check=True)
json.dump(idx,open(out+'.json','w'),indent=0)
