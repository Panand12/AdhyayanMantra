#!/bin/bash

#password attempts left
passwordAttempts=2

#To check if password  is correctpassword
correctpassword=0

#Dynamic location for package installer
location=$1

#Updated Version  of the app
updatedVersion=$2

#To prompt user for admin credentials
results=$(/usr/bin/osascript -e "display dialog   \"Kindly enter Administrator password to continue installation\" with title \"Authentication Required \" default answer \"\" with hidden answer buttons {\"OK\"} default button {\"OK\"}" )

#Password entered buy the user
Password=$( echo "$results" | /usr/bin/awk -F "text returned:" '{print $2}' )

#To check if user entered correct admin password or not
passwordAttempts=3

#To check if password  is correctpassword
correctpassword=0

#While password attempts remains
while [[ "$passwordAttempts" >0 ]]
do
echo $Password | sudo -S -v
if sudo -n true 2>/dev/null;then
  correctpassword=1
break
else
results=$( /usr/bin/osascript -e "display dialog \"Password entered is incorrect.\nTotal remaining attempts: $passwordAttempts\" with title \"Authentication Failure \" default answer \"\" with hidden answer buttons {\"OK\"} default button {\"OK\"}" )
Password=$( echo "$results" | /usr/bin/awk -F "text returned:" '{print $2}' )
fi
  ((passwordAttempts--))
done

#If the password is correct
if [[ $correctpassword -eq 1 ]];then

 #Installer command to hidden  install package file automatically
  sudo installer -pkg $location -target /Applications
  
  #To close exixting opened vDesk
  sudo killall vDesk
  
  #Remove Upgrade app folder
  rm -R  ~/library/caches/vDesk_ApplicationFiles/UpdateFolder
  
  #To save Updated version of app in .txt file to show  upgraded successfully  dialog to user
  
  echo UpdatedVersion:$updatedVersion > ~/library/caches/vDesk_ApplicationFiles/Update.txt
  
  #Open Updated vDesk
  open -a vDesk

else

  rm -R  ~/library/caches/vDesk_ApplicationFiles/UpdateFolder
  
  /usr/bin/osascript -e "display dialog \"Unable to authenticate root credentials. Please try again or contact your administrator.\" with title \"Authentication Failure \" buttons {\"OK\"} default button {\"OK\"}"

fi


