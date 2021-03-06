# -*-mic2-options-*- -A armv7l -f loop --pack-to=@NAME@.tar.gz -*-mic2-options-*-

# 
# Do not Edit! Generated by:
# kickstarter.py
# 

lang en_US.UTF-8
keyboard us
timezone --utc Asia/Seoul
# ROOT fs partition
part / --size=2000 --ondisk mmcblk0p --fstype=ext4 --label=rootfs --extoptions="-J size=16"
# DATA partition
part /opt/ --size=312 --ondisk mmcblk0p --fstype=ext4 --label=system-data --extoptions="-m 0"
# UMS partition
part /opt/usr/ --size=3000 --ondisk mmcblk0p --fstype=ext4 --label=user --extoptions="-m 0"

rootpw tizen 
bootloader  --timeout=0  --append="rootdelay=5"   

desktop --autologinuser=root  
user --name root  --groups audio,video --password ''

repo --name=local-packages --baseurl=file:///home/redcarrottt/GBS-ROOT/local/repos/tizen2.3/armv7l/ --priority=1
repo --name=2.3-mobile-target --baseurl=http://download.tizen.org/releases/2.3/2.3-mobile/tizen-2.3-mobile_20150206.1/repos/target/packages/ --save  --ssl_verify=no --priority=2

%packages

@target-m
@eng-tools-m


%end

%prepackages
libprivilege-control-conf
rpm-security-plugin
%end


%post
echo 'kickstart post script start'

rm -rf /usr/include
rm -rf /usr/share/man
rm -rf /usr/share/doc

ldconfig

if [ ! -L var ]; then
        [ -d opt ] || mkdir opt
        cp -af var opt
        rm -rf var
        ln -snf opt/var var
        rm -rf opt/var/run
        ln -snf /run opt/var/run
fi
rm -f /var/lib/rpm/__db*
rm -rf /var/lib/rpmrebuilddb*

LICENSE_DIR=/usr/share/license
LICENSE_FILE=/usr/share/license.html
MD5_TEMP_FILE=/usr/share/temp_license_md5

if [[ -f $LICENSE_FILE ]]; then
        rm -f $LICENSE_FILE
fi

LICENSE_LIST=`ls $LICENSE_DIR`

if [[ -f $MD5_TEMP_FILE ]]; then
        rm -f $MD5_TEMP_FILE
fi

cd $LICENSE_DIR

for INPUT in $LICENSE_LIST; do
        if [[ -f $INPUT ]]; then
                md5sum $INPUT >> $MD5_TEMP_FILE
        fi
done

MD5_LIST=`cat $MD5_TEMP_FILE|awk '{print $1}'|sort -u`

echo "<html>" >> $LICENSE_FILE
echo "<head>" >> $LICENSE_FILE
echo "<meta name=\"viewport\" content=\"initial-scale=1.0\">" >> $LICENSE_FILE
echo "</head>" >> $LICENSE_FILE
echo "<body>" >> $LICENSE_FILE
echo "<xmp>" >> $LICENSE_FILE

for INPUT in $MD5_LIST; do
        PKG_LIST=`cat $MD5_TEMP_FILE|grep $INPUT|awk '{print $2}'`
        PKG_NAME=`echo $PKG_LIST|awk '{print $1}'`

        echo "$PKG_LIST :" >> $LICENSE_FILE
        cat $PKG_NAME >> $LICENSE_FILE
        echo  >> $LICENSE_FILE
        echo  >> $LICENSE_FILE
        echo  >> $LICENSE_FILE
done

echo "To obtain the source code covered under above licenses, please visit http://opensource.samsung.com/ ." >> $LICENSE_FILE
echo "</xmp>" >> $LICENSE_FILE
echo "</body>" >> $LICENSE_FILE
echo "</html>" >> $LICENSE_FILE

rm -rf $LICENSE_DIR/* $MD5_TEMP_FILE

/etc/make_info_file.sh Mobile-RD-PQ Tizen-2.3.0_Mobile-RD-PQ_`date +%Y%m%d.%H%M`

if [ -e $INSTALL_ROOT/usr/bin/install-smack-policy.sh ]; then
	$INSTALL_ROOT/usr/bin/install-smack-policy.sh
fi


%end

%post --nochroot
if [ -e $INSTALL_ROOT/usr/bin/build-backup-data.sh ]; then
	$INSTALL_ROOT/usr/bin/build-backup-data.sh
fi


%end
