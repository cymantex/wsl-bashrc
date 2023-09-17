#########################
# NPX Utils
#########################

function npxCreateNextAppTypescript() {
  npm create next-app --typescript
  npm install -D tailwindcss postcss autoprefixer
  npx tailwindcss init -p
}

function npxCreateViteReactApp() {
  npm create vite@latest $1 -- --template react-ts
  cd $1 || exit
  npm i
}

function npxInstallTailwind() {
	npm install -D tailwindcss postcss autoprefixer
	npx tailwindcss init -p
}

