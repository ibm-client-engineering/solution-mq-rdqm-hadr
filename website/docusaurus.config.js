// @ts-check
// Note: type annotations allow type checking and IDEs autocompletion

const lightCodeTheme = require('prism-react-renderer/themes/github');
const darkCodeTheme = require('prism-react-renderer/themes/dracula');
const {Info} = require('./variables.js');

/** @type {import('@docusaurus/types').Config} */
const config = {
  markdown: {
    mermaid: true,
  },
  themes: ['@docusaurus/theme-mermaid'],
  title: 'IBM Client Engineering',
  tagline: 'Build Faster. Together.',
  favicon: 'img/favicon.ico',

  // Set the production url of your site here
  url: Info.url,
  // Set the /<baseUrl>/ pathname under which your site is served
  // For GitHub pages deployment, it is often '/<projectName>/'
  baseUrl: Info.baseUrl,

  // GitHub pages deployment config.
  // If you aren't using GitHub pages, you don't need these.
  organizationName: Info.org, // Usually your GitHub org/user name.
  projectName: Info.project, // Usually your repo name.

  onBrokenLinks: 'warn',
  onBrokenMarkdownLinks: 'warn',

  trailingSlash: false,

  // ...
  plugins: [require.resolve("@cmfcmf/docusaurus-search-local")],

  // or, if you want to specify options


  // Even if you don't use internalization, you can use this field to set useful
  // metadata like html lang. For example, if your site is Chinese, you may want
  // to replace "en" with "zh-Hans".
  i18n: {
    defaultLocale: 'en',
    locales: ['en'],
  },

  presets: [
    [
      'classic',
      /** @type {import('@docusaurus/preset-classic').Options} */
      ({
        docs: {
          routeBasePath: '/',
          sidebarPath: require.resolve('./sidebars.js'),
          // Please change this to your repo.
          // Remove this to remove the "edit this page" links.
          editUrl: Info.repo,
        },
        theme: {
          customCss: require.resolve('./src/css/custom.css'),
        },
      }),
    ],
  ],

  themeConfig:
    /** @type {import('@docusaurus/preset-classic').ThemeConfig} */

    ({
      metadata: [{name: 'keywords', content: 'ibm client engineering, open solutions library,  filenet, eks, aws, cp4ba, filenet on aws eks'}],
      mermaid: {
        theme: { light: 'neutral', dark: 'dark' },
      },
      // Replace with your project's social card
      image: 'img/logo.svg',
      tableOfContents: {
        minHeadingLevel: 2,
        maxHeadingLevel: 5,
    },
      navbar: {
        title: '| Middleware Automation',
        logo: {
          alt: 'My Site Logo',
          src: 'img/logo.svg',
          srcDark: 'img/logo-dark.svg',
          width: 200,
          height: 200,
        },
        items: [
          // {
          //   type: 'doc',
          //   docId: 'intro',
          //   position: 'left',
          //   label: 'Section',
          // },

          {
            href: 'https://github.com/${vars.org}/${vars.project}',
            className: "header-github-link",
            position: 'right',
          },
        ],
      },
      footer: {
        // style: 'dark',
        links: [
          {
            title: 'Links',
            items: [
              {
                label: 'IBM',
                to: 'https://www.ibm.com/',
              },
              {
                label: 'IBM Client Engineering',
                to: 'https://www.ibm.com/client-engineering',
              },
            ],
          }

        ]
      },
      prism: {
        theme: lightCodeTheme,
        darkTheme: darkCodeTheme,
      },
    }),
};

module.exports = config;


