function sshdev --wraps='ssh -X zhangkui.007@10.248.188.226' --description 'alias sshdev=ssh -X zhangkui.007@10.248.188.226'
  ssh -X zhangkui.007@10.248.188.226 $argv; 
end
