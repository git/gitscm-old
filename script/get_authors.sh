export GIT_DIR=/Users/schacon/projects/git/.git
git log --pretty=format:"%an" | sort | uniq -c | sort -nr > ../config/authors.txt
git log --pretty=format:"%an:%ae" | sort | uniq > ../config/authors_emails.txt
