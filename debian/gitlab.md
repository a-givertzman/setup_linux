
### Configuration
edit file:
sudo nano /etc/gitlab/gitlab.rb

then run reconfigure:
sudo gitlab-ctl reconfigure

# external_url 'http://gitlab.tkz-asu.com'
external_url 'http://192.168.120.178'


#### Configure the location to the git data folder
git_data_dirs({
  "default" => {
    "path" => "/mnt/storage0/git-storage"
   }
})


### Change the data directory gitlab to store repos elsewhere

Just updating in case people still refer to this. From the GitLab (documentation)[https://gitlab.com/gitlab-org/omnibus-gitlab/blob/master/doc/settings/configuration.md#storing-git-data-in-an-alternative-directory]:

    By default, omnibus-gitlab stores the Git repository data under /var/opt/gitlab/git-data. The repositories are stored in a subfolder repositories. You can change the location of the git-data parent directory by adding the following line to /etc/gitlab/gitlab.rb.

    git_data_dirs({"default" => "/mnt/nas/git-data"})

    Starting from GitLab 8.10 you can also add more than one git data directory by adding the following lines to /etc/gitlab/gitlab.rb instead.

    git_data_dirs({
      "default" => "/var/opt/gitlab/git-data",
      "alternative" => "/mnt/nas/git-data"
    })

    Note that the target directories and any of its subpaths must not be a symlink.

    Run sudo gitlab-ctl reconfigure for the changes to take effect.

    If you already have existing Git repositories in /var/opt/gitlab/git-data you can move them to the new location as follows:

    # Prevent users from writing to the repositories while you move them.
    sudo gitlab-ctl stop

    # Note there is _no_ slash behind 'repositories', but there _is_ a
    # slash behind 'git-data'.
    sudo rsync -av /var/opt/gitlab/git-data/repositories /mnt/nas/git-data/
    sudo rsync -av lobanov@192.168.120.185:/home/lobanov/kvm/fromsrv/git-storage /mnt/storage0/git-storage/

    # Fix permissions if necessary
    sudo gitlab-ctl reconfigure

    # Double-check directory layout in /mnt/nas/git-data. Expected output:
    # gitlab-satellites  repositories
    sudo ls /mnt/nas/git-data/

    # Done! Start GitLab and verify that you can browse through the repositories in
    # the web interface.
    sudo gitlab-ctl start



### Diagnosis

sudo gitlab-ctl stop
sudo gitlab-ctl start
sudo gitlab-ctl restart

sudo gitlab-rake gitlab:check --trace

sudo gitlab-rake db:migrate:status --trace


### Additional commands, do not use antil have deep anderstanding

sudo gitlab-rake db:migrate:redo
