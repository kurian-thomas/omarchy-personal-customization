# Installing AppImages as applications for quick select

1. Create a dedicated folder to store the AppImage and make it executable 

```
mkdir -p ~/Applications
mv ~/Downloads/App.AppImage ~/Applications/
chmod +x ~/Applications/App.AppImage
```

2. Create the Desktop Entry You need to create a text file in ```~/.local/share/applications/``` that tells Linux how to run the app.

```
eg: ~/.local/share/applications/app.desktop
```

3. Desktop Entry Details

```
[Desktop Entry]
Name=Your App Name
Exec=/home/yourusername/Applications/YourApp.AppImage
Icon=utilities-terminal
Type=Application
Categories=Utility;
```


