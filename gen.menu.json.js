#!/usr/bin/env node
const kterm_scripts=
      ["LinuxDeploy",
       [["Linux",
	 [
	     ["Install Alpine Linux","./install.alpine.sh"],
	     ["Umount","./umount.sh"],
	     ["Resize rootfs","./resize.sh"],
	     ["Remove rootfs",
	      [["Yes,Remove rootfs","./remove.sh"],
	       ["No",null]],
	     ]]]]]

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
