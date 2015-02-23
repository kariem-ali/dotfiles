@echo off

mklink /H %userprofile%\.bashrc .bashrc.win32
mklink /H %userprofile%\.gitconfig .gitconfig
mklink /H %userprofile%\.vimperatorrc .vimperatorrc

mklink /H %userprofile%\.vimrc .vimrc
mklink /J %userprofile%\.vim .vim

echo All done. Press any key to exit
pause
