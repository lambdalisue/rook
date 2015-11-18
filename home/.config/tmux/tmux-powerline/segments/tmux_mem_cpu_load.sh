# Print out Memory, cpu and load using https://github.com/thewtex/tmux-mem-cpu-load

run_segment() {
	type tmux-mem-cpu-load >/dev/null 2>&1
	if [ "$?" -ne 0 ]; then
		return
	fi

	stats=$(tmux-mem-cpu-load --colors --interval 2 $(nporc))
	if [ -n "$stats" ]; then
		echo "$stats";
	fi
	return 0
}
