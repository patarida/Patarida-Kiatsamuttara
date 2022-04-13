#!/bin/bash

# Long Assignment 4 - FolderCreation.sh
# This program will create a new folder structure under /EmployeeData
# 1. Create /EmployeeData
# 2. Create deparments' folder
# 3. Limit the permission in each departments'folder
# 4. Each folder should have it's associated department group assigned as the owner
# 5. A message should be shown to the user before the program exits : how many folders were created.

# 1. Create /EmployeeData
sudo mkdir /EmployeeData

# 2. Create deparments' folder
sudo mkdir /EmployeeData/HR /EmployeeData/IT /EmployeeData/Finance /EmployeeData/Executive /EmployeeData/Administrative /EmployeeData/"Call Centre"

# 3. Limit the permission in each departments'folder including all future subfolders
sudo chmod -R 760 /EmployeeData/HR
sudo chmod -R 764 /EmployeeData/IT
sudo chmod -R 764 /EmployeeData/Finance
sudo chmod -R 760 /EmployeeData/Executive
sudo chmod -R 764 /EmployeeData/Administrative
sudo chmod -R 764 /EmployeeData/"Call Centre"

# 4. Each folder should have it's associated department group assigned as the owner
sudo chgrp HR /EmployeeData/HR
sudo chgrp IT /EmployeeData/IT
sudo chgrp Finance /EmployeeData/Finance
sudo chgrp Executive /EmployeeData/Executive
sudo chgrp Administrative /EmployeeData/Administrative
sudo chgrp CallCentre /EmployeeData/"Call Centre"

# 5. A message should be shown to the user before the program exits : how many folders were created.
echo The program is finished.
echo $(($(ls /EmployeeData | wc -l)+1)) folders have been created.
