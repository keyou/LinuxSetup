function nleimage.apply --wraps='adb shell am broadcast -a nleimage.apply --es id' --description 'alias nleimage.apply=adb shell am broadcast -a nleimage.apply --es id'
  adb shell am broadcast -a nleimage.apply --es id $argv; 
end
