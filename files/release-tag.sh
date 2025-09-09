day=$(date +"%Y-%m-%d")
TAG="release-$day"

git tag -a $TAG -m "Released at: $day"
