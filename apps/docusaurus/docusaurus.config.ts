import type { Config } from '@docusaurus/types';

/**
 * Single-instance docs site over the co-located `docs/`. Workspace docs are
 * authored there directly; per-package docs live in each package's `docs/`
 * folder and are assembled under `docs/<category>/` (one folder per `doc:` tag) by the
 * `@fmmenchi/nx-docusaurus` config-generator + sync-docs executors (the
 * `build`/`serve` targets depend on them).
 *
 * The skills are linked from the home page to their SKILL.md on GitHub, never
 * copied here: a skill directory ships whole, and a second copy would drift.
 */
const config: Config = {
  title: 'ai-skills',
  url: 'https://fmmenchi.github.io',
  baseUrl: '/ai-skills/',
  // The assembled tree is self-contained: every in-site link must resolve —
  // a broken cross-package link fails the build.
  onBrokenLinks: 'throw',
  markdown: {
    // .md stays CommonMark (docs prose with <placeholders> and {braces} must
    // not be parsed as JSX); .mdx opts into MDX explicitly.
    format: 'detect',
    hooks: { onBrokenMarkdownLinks: 'warn' },
  },
  i18n: { defaultLocale: 'en', locales: ['en'] },
  presets: [
    [
      'classic',
      {
        docs: {
          path: 'docs',
          routeBasePath: '/',
          sidebarPath: './sidebars.ts',
        },
        blog: false,
        theme: { customCss: './src/css/custom.css' },
      },
    ],
  ],
  themeConfig: {
    navbar: {
      title: 'ai-skills',
      items: [
        {
          href: 'https://github.com/fmmenchi/ai-skills',
          label: 'GitHub',
          position: 'right',
        },
      ],
    },
  },
};

export default config;
