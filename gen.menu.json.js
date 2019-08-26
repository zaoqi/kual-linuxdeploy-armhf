#!/usr/bin/env node
const kterm_scripts=
      ["LinuxDeploy",
       [["Linux",
	 [
	     ["Install",[
		  ["Alpine Linux Edge","./install.alpine.sh"],
		  ["Ubuntu 19.04(maybe require Linux 4.x?)","./install.ubuntu.1904.sh"]]],
	     ["Change mirror",[
		 ["China Mainland","./mirror.china.sh"]]],
	     ["Add a sudo-enabled user called \"kindle\"","./install.sudo.user.sh"],
	     ["Reset \"kindle\" user's password","./set.user.password.sh"],
         ["USER=kindle Install desktop environment",
          ["Xfce4","./install.de.xfce4.sh"],
          ["awesome","./install.de.awesome.sh"]],
         ["USER=kindle Start desktop environment",
          ["xfce4","./chroot.de.xfce4.user.sh"],
          ["awesome","./chroot.de.awesome.user.sh"]],
	     ["Shell",[
		  ["USER=kindle","./chroot.shell.user.sh"],
		  ["USER=root","./chroot.shell.sh"]]],
	     ["Add/Resize swap file","./make.swap.sh"],
	     ["Remove swap file",
	      [["Yes,remoce swap file","./remove.swap.sh"],
	       ["No",null]]],
	     ["Umount","./umount.sh"],
	     ["Resize rootfs","./resize.sh"],
	     ["Remove rootfs",
	      [["Yes,remove rootfs","./remove.sh"],
	       ["No",null]]]]]]]

function translate_kterm_scripts(name,priority,script){
    if(script===null||script===void 0){
	return {
	    name: name,
	    priority: priority,
	}
    }else if(typeof script==='string'){
	return {
	    name: name,
	    priority: priority,
	    action:"/mnt/us/extensions/kterm/bin/kterm.sh",
	    params:"-e "+script,
	}
    }else{
	return {
	    name: name,
	    priority: priority,
	    items: script.map((x,index)=>translate_kterm_scripts(x[0],index,x[1])),
	}
    }
}

console.log(JSON.stringify(translate_kterm_scripts(kterm_scripts[0],0,kterm_scripts[1]),null,2))
