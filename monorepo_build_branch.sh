BUILD_BRANCH=$1

echo ${BUILD_BRANCH}
mkdir -p ./monorepo/${BUILD_BRANCH}
cd ./monorepo/${BUILD_BRANCH}
echo $(pwd)

ORIGIN_SSH=<repo ssh url here>
REPO_1_SUBDIRECTORY=<repo 1 subdirectory name>
REPO_1_SSH=<repo ssh url here>

git init
git remote add origin ${ORIGIN_SSH}
git remote add ${REPO_1_SUBDIRECTORY} ${REPO_1_SSH}
# add more "git remote" for additional repo's here.
git fetch origin initializer
git fetch ${REPO_1_SUBDIRECTORY} ${BUILD_BRANCH}
# add more "git fetch" for additional repo's here.

# see monorepo_build for usage information.
../../monorepo_build.sh origin:origin/../ ${REPO_1_SUBDIRECTORY}#:${REPO_1_SUBDIRECTORY}