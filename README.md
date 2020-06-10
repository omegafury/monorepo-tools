
This is a fork of the Shopsys Monorepo Tools set of bash functions. The original library handles migrating multiple repositories into a single monorepo, however, it only migrates all branches of the first provided repository, then only migrates master for all other repos. We needed a slightly more dynamic migration, as we wanted to keep more than just the master of all migrated repo's, so some significant modification of the original scripts has been done. To that end, this version will only handle migrating INTO a monorepo from several reposities, and will NOT handle migrating back out into separate repos from a monorepo, like the original scripts do.

To get this working you'll need a set of repos you want to migrate, as well as a repository to serve as the monorepo. This monorepo should have a branch called "initializer", and can have as much or as little in it as you want. Ours just had an empty README.md and a .gitignore file.  This branch will be used as the initial set of changes when generating each new monorepo branch you're migrating from your child repositories. 

## Quick start

### 1. Download

First download this repository so you can use the tools (eg. into `~/monorepo-tools`).

### 2. Preparing an empty repository for the monorepo
In Git you'll want to prepare a new repository that will be your monorepo. This repository needs to contain a branch called "initializer". The initializer branch can have as much or as little in it as you want, but it will be used as the staging point for building each branch you migrate, and will therefore have its contents be present in each migrated branch. In our migration this branch simply contained an empty README.md and a .gitignore containing all of the .gitignore contents from our repos being migrated. You'll need to preface each .gitignore entry from your repos with the subdirectory that the code will be in after migration.

For example, you have a frontend repository with a .gitignore that only contains the following:
```
node_modules
```

In the monorepo .gitignore, you'll want something like this:
```
/frontend/node_modules
```

### 3. Preparing your repositories for migration
For each final branch you want in your monorepo, you'll need to make sure that each repo you want to migrate has a branch with that corresponding name. If one doesn't already exist, then you'll need to create one.

For example, you want to migrate the feature branch FEATURE-1, and you're migrating 3 repos to your monorepo. 2 of the 3 have a FEATURE-1 branch, but the 3rd repo doesn't. You'll need to pick a branch in the 3rd repo to branch off of and create a FEATURE-1 branch so the migration can run. This would likely be something like develop or master.

Finally, to ensure you have a smooth post migration cleanup, you should do a final merge down your branch chain to ensure that the git histories for your various branches are in sync. Without doing this, you'll successfully migrate each branch, but each branch will show a FULL diff of the entire repo if you compare them, and it will be difficult to rectify this. Doing it in the individual repos first will make your life easier later.

For example, you have this branch structure:
* master
    * rc-2.0.0
    * develop
        * FEATURE-1

So for this you'll want to merge master into the rc and develop branches, and develop into FEATURE-1 and resolve any problems before continuing. This process will HAVE to be done later if it isn't done now, and it'll probably be easier if you do it in each individual repo. Really just depends on how out of sync they are.

### 4. Preparing the scripts
In monorepo_initialize_and_build.sh you'll need to update BRANCH_LIST with the list of branches you would like to migrate.

In monorepo_build_branch.sh you'll need to make sure your main monorepo ssh url is set as origin, as well as adding the subdirectory and ssh url for each repo you want to migrate.

### 5. Running the scripts
Run the scripts with:
```
sh ./monorepo_initialize_and_build.sh
```
This will spin off a child process for each branch you're migrating. These scripts will create a directory ./monorepo/<branch> for each branch you provided in BRANCH_LIST. This will then init a git repository, attach the remotes for the origin monorepo as well as repositories you're migrating. It will then fetch the branch you want to migrate.

With the git repo initialized, the monorepo_build.sh script will take the history from each repo you're migrating, and rewrite it as if it was originaly done inside the subdirectory where it will reside in the monorepo. This will ensure that both yor full commit history, as well as your individual file change history, is preserved. If you simply do a git subtree merge instead of this history rewrite process, you'll lose all file history, which is obviously undesirable.

#### This history rewrite process will take a long time

After the history rewrite is finished for each branch, the changes will be merged together into a final commit, and this will be pushed up to your origin repository under the branch it was migrating.

### 6. Post script cleanup
At this point your remote origin repository should have a fully migrated branch for each branch you provided in BRANCH_LIST. If you diff these branches, you should see the correct commit diff, but the entire repository will be diffed, which obviously isn't correct. I'm as of yet uncertain why this is, but I think it has to do with the fact that since we've rewritten the history for each branch, it no longer knows that the branches themselves are related, and therefore diffs the entire set of files in the repo. You now just need to do the exact same set of merges you did in step 3. These merges will probably end up just being empty, but it will sync up each set of branches, fixing the diff.

### 7. Next steps
At this point you should have a functional monorepository. You'll likely need to do additional build configuration updating that's specific to your project, but you should have a fully migrated set of branches that diff each other correctly, as well as still have the full commit history for both the project at large, as well as individual files.

## Additional Notes
For the original README, see the master branch. This contains the unedited code at the time this repo was forked. The changes for this branch were significant enough that I felt a new README was better than trying to have users parse through the old one and figure out what was 

## Author
Andrew Poe
