BRANCH_LIST=("master" "develop")

rm -rf ./monorepo

for BUILD_BRANCH in ${BRANCH_LIST[@]}; do
    ./monorepo_build_branch.sh ${BUILD_BRANCH} &
done

echo "DONE LAUNCHING MONOREPO THREADS"