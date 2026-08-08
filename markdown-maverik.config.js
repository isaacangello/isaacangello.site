export default {
  dir: 'src/posts',
  out: 'src/posts/index.json',
  marked: { gfm: true, breaks: true },
  frontmatter: {
    title: 'string',
    date: 'string',
    tags: 'array',
    description: 'string',
    prefix: 'string'
  },
  prefixes: {
    tec: { label: 'Tec', name: 'Tecnologia' },
    pol: { label: 'Pol', name: 'Política' },
    dev: { label: 'Dev', name: 'Desenvolvimento' },
    rel: { label: 'Rel', name: 'Religião' },
    others: { label: 'Others', name: 'Outros' }
  }
}
