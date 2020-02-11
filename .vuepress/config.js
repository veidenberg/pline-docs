module.exports = {
    title: 'Pline',
    description: 'Modern web interfaces for CLI programs',
    base: '/pline/',
    head:[
	    ['script', {type:"text/javascript", src:"https://cdnjs.cloudflare.com/ajax/libs/jquery/3.4.0/jquery.min.js"}],
	    ['script', {type:"text/javascript", src:"https://cdnjs.cloudflare.com/ajax/libs/knockout/3.5.0/knockout-min.js"}],
        ['script', {type:"text/javascript", src:"/pline.js"}],
        ['script', {type:"text/javascript", src:"https://cdnjs.cloudflare.com/ajax/libs/prism/1.19.0/components/prism-core.min.js"}],
        ['script', {type:"text/javascript", src:"https://cdnjs.cloudflare.com/ajax/libs/prism/1.19.0/components/prism-bash.min.js"}],
        ['script', {type:"text/javascript", src:"https://cdnjs.cloudflare.com/ajax/libs/prism/1.19.0/components/prism-json.min.js"}],
        ['script', {type:"text/javascript", src:"/analytics.js"}],
        ['link', {rel:"stylesheet", type:"text/css", href:"/pline.css"}],
        ['link', { rel: 'icon', href: '/images/pline_logo.png' }]
    ],
    markdown: { anchor: { permalink: false } },
    themeConfig: {
	    logo: '/images/pline_logo.png',
        nav: [
          {text: '🏠 Home', link: '/'},
          {text: '📖 Docs', link: '/guide/'},
          {text: '📦 Downloads', link: '/downloads/'},
          {text: 'GitHub', link: 'https://github.com/veidenberg/pline'}
        ],
        sidebar: {
            '/guide/': ['', 'api'],
            '/downloads/': [''],
            '/': ['']  //fallback page
        },
        smoothScroll: true,
        cache: false
    },
    plugins: ['@vuepress/back-to-top']
}