if [ -n \"\$BASH_VERSION\" ] || [ -n \"\$ZSH_VERSION\" ]; then
	source $PREFIX/share/chruby/chruby.sh
	source $PREFIX/share/chruby/auto.sh
fi
