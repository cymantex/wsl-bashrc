#########################
# NPM Utils
#########################

function npmCreateNextAppTypescript() {
  npm create next-app --typescript
  npm install -D tailwindcss postcss autoprefixer
  npx tailwindcss init -p
}

function npmCreateViteReactApp() {
  npm create vite@latest $1 -- --template react-ts
  cd $1 || exit
  npm i
}

function npmInstallTailwind() {
	npm install -D tailwindcss postcss autoprefixer
	npx tailwindcss init -p
}

