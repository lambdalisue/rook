# Execute IPython Notebook if it is available
RUN_SERVER="$HOME/.ipython/profile_default/run_notebook_server.sh"
if [[ -x "ipython" -a -x "$RUN_SERVER" ]]; then
    $RUN_SERVER
fi
