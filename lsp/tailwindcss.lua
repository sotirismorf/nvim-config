return {
  cmd = { 'tailwindcss-language-server', '--stdio' },
  filetypes = { 'templ', 'javascript', 'typescript', 'react' },
  root_markers = { 'go.work', 'go.mod', '.git' },
  settings = {
    tailwindCSS = {
      includeLanguages = {
        templ = 'html',
      },
    },
  },
}
