module.exports = {
    title: 'Pline',
    description: 'Modern web interfaces for CLI programs',
    base: '/pline/',
    //dest: '.vuepress/.nosync', //for excluding from iCloud
    head:[
	    ['script', {type:"text/javascript", src:"https://cdnjs.cloudflare.com/ajax/libs/jquery/3.4.0/jquery.min.js"}],
	    ['script', {type:"text/javascript", src:"https://cdnjs.cloudflare.com/ajax/libs/knockout/3.5.0/knockout-min.js"}],
        ['script', {type:"text/javascript", src:"/pline.js"}],
        ['link', {rel:"stylesheet", type:"text/css", href:"/pline.css"}]
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
        lastUpdated: 'Last updated',
        smoothScroll: true,
        cache: false
    }
}