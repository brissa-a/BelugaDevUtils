How to merge your repository with the main one
==============================================

1.  Add main repository as remote in your local git folder (Beluga or BelugaDemo):
    
    *Remote add main https://github.com/HaxeBeluga/Beluga_or_BelugaDemo*

2.  Set the main repository as read-only. In your repository folder:
    
    *git config remote.origin.pushurl "you really didn't want to do that"*

3. now you can merge main repository with yours with: *git pull main master*

4. then push to origin to sync all repositories
