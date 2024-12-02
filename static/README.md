# Flask Web App Steps And Note For The GCRG MySQL DB

## Prj set up ##

The app lives in a directory called db_web_framework on a university pbsci server.
1. Working with VSCode
    * Download VSCode
    * Add Python extension
    * Add Remote Development Extension, I think this includes a bunch of other stuff. It will allow you to add the ssh path and then interface with the files and like you would locally. This might also be a great way to work with HPC environments like Wahab in the future.
    * There is an icon of a monitor with a circle in the bottom right with something like "><" in side it. Click this to start the remote connection.
    * Under ssh add the connection, you will type what it wants in the search bar at the top. This will be "ssh <usrname@pbsci.other.stuff>". It seems to ask me for my password a lot. I'll probably look into that eventually. 
2. Setting up the environment. 
    * Run the following. We are setting up a python environment so that there are no issues with local package differences. Everything will be self contained in the virtual environment.
```bash
pip3 install virtualenv
# As of right now it seems packages install locally instead of at root. I don't seem to have root privileges, but it might not matter.
../.local/bin/virtualenv env
source env/bin/activate
# Things will now install to the env. You will see an (env) in front of your usr name in the terminal
pip3 install flask
pip3 install mysql.connector
pip3 install markdown2
```
    * each time you log in you will need to source the environment. It was doing this automatically before when I was working locally, but not with the vm it seems.

3. Project Directory Structure
    * For a web app there seems to be a magical directory structure where the names of the directories are standardized so everything knows where everything else is. This will follow that. The directories include:
        * _pycache_/
        * env 
        * static/css/
        * templates/
        * uploads/