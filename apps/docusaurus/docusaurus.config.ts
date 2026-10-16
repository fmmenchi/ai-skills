import type { Config } from '@docusaurus/types';

/**
 * One docs instance, rooted at the REPOSITORY, not at the co-located `docs/` the
 * `@fmmenchi/nx-docusaurus` site generator points it at. ADR 0004.
 *
 * `README.md`, the ADRs and the skills are served from where they are written.
 * Nothing is copied or moved: `doc/adr/` is referenced by commits, memory and
 * AGENTS.md, and a skill directory is symlinked whole into every tool, so neither
 * may grow site-only files.
 *
 * ONE instance, and that is not taste. A second instance whose directory lies
 * inside this one's (the generator's `docs/` does) has its Markdown matched by
 * both instances' loaders and compiled twice: measured, the page rendered as the
 * literal text `export const frontMatter = {`, and the build stayed green.
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
          path: '../..',
          routeBasePath: '/',
          sidebarPath: './sidebars.ts',
          // An allow-list, never a walk of the root: node_modules and the
          // worktrees under .claude/ must stay out. `contract/` and
          // `.agents/doc/` are written for agents, not people, and are left out
          // on purpose. The last line is where the plugin's sync-docs assembles
          // any Nx project's own docs/ — none today, kept so that one would show.
          include: [
            'README.md',
            'doc/adr/*.md',
            'skills/*/SKILL.md',
            'skills/*/references/**/*.md',
            'apps/docusaurus/docs/**/*.{md,mdx}',
          ],
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
          type: 'docSidebar',
          sidebarId: 'skills',
          label: 'Skills',
          position: 'left',
        },
        {
          type: 'docSidebar',
          sidebarId: 'adr',
          label: 'Decisions',
          position: 'left',
        },
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
