## This is just a personal helper script/function I use to help create and manage virtual environments in Python.<br>
```
venv help  
venv [command] [arg]

commands:
  create | c <name>     create virtualenv
  activate | a <name>   activate virtualenv
  list | l <name>       list packages in virtualenv
  find | f <package>    search for package in all envs
  nuke | n <name>       delete virtualenv
  upgrade | u <name>    upgrade pip and setuptools in virtualenv
  export | e <name>     export requirements.txt from virtualenv
  install | i <name>    install from requirements.txt in virtualenv
  (no args)             list all available virtual environments
```

Just add this to $ZSH_CUSTOM/functions.zsh and source $ZSH_CUSTOM/functions.zsh
The $ZSH_CUSTOM dir gets sourced at login which will include the function everytime you log in.

If you find any bugs please lket me know or make a pull request and i will review it and merge it if there are no problems
