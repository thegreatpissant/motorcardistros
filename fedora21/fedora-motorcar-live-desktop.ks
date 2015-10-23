# Maintained by the Fedora Desktop SIG:
# http://fedoraproject.org/wiki/SIGs/Desktop
# mailto:desktop@lists.fedoraproject.org

%include fedora-live-base.ks
%include fedora-motorcar-packages.ks

part / --size 6144

%pre 
#mkdir -p $INSTALL_ROOT/repos
#cp -R /repo/fedora $INSTALL_ROOT/repos/
%end

%post
##  Install Motorcar stuff
mkdir /repos
mount 10.0.1.5:/home/repos /repos
cd /repos/fedora/releases/21/Everything/x86_64/
dnf -y install qt5*.rpm
rpm -i --force --nodeps *.rpm

cd /repos/motorcar/sixenseSDK_linux_OSX
cp install/99-six* /usr/lib/udev/rules.d/
cp lib/linux_x64/release/libsixense_utils_x64.so /usr/lib64/
cp lib/linux_x64/release/libsixense_x64.so /usr/lib64/
chmod 755 /usr/lib64/libsixense*
cd /repos/motorcar/OculusSDKv2.3
cp ./LibOVR/90-oculus.rules /lib/udev/rules.d/
cp ./LibOVR/Lib/Linux/Release/x86_64/libovr.a /usr/lib64/
chmod 755 /usr/lib64/libovr.a
ldconfig
# checkout the Motorcar sources
cd ~liveuser/
mkdir -p Projects/Motorcar/src
cd Projects/Motorcar/src
git clone https://github.com/evil0sheep/motorcar.git

cat >> /etc/rc.d/init.d/livesys << EOF


# disable updates plugin
cat >> /usr/share/glib-2.0/schemas/org.gnome.software.gschema.override << FOE
[org.gnome.software]
download-updates=false
FOE

# don't run gnome-initial-setup
mkdir ~liveuser/.config
touch ~liveuser/.config/gnome-initial-setup-done


# rebuild schema cache with any overrides we installed
glib-compile-schemas /usr/share/glib-2.0/schemas

# set up auto-login
cat > /etc/gdm/custom.conf << FOE
[daemon]
AutomaticLoginEnable=True
AutomaticLogin=liveuser
FOE

# Turn off PackageKit-command-not-found while uninstalled
if [ -f /etc/PackageKit/CommandNotFound.conf ]; then
  sed -i -e 's/^SoftwareSourceSearch=true/SoftwareSourceSearch=false/' /etc/PackageKit/CommandNotFound.conf
fi

# make sure to set the right permissions and selinux contexts
chown -R liveuser:liveuser /home/liveuser/
restorecon -R /home/liveuser/

EOF 
%end
