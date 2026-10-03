local jdtls = require 'jdtls'

-- ============================================================
-- Project root
-- ============================================================

local root_markers = {
  -- Gradle
  'gradlew',
  'gradlew.bat',
  'settings.gradle',
  'settings.gradle.kts',

  -- Maven
  'pom.xml',

  -- Fallback
  '.git',
}

local root_dir = require('jdtls.setup').find_root(root_markers)

if not root_dir then
  vim.notify('JDTLS: project root could not be detected', vim.log.levels.WARN)
  return
end

-- ============================================================
-- JDTLS workspace
-- ============================================================

local project_name = vim.fn.fnamemodify(root_dir, ':t')

local workspace_dir = vim.fn.stdpath 'data' .. '/site/java-workspace/' .. project_name

-- Creează directorul dacă nu există deja.
vim.fn.mkdir(workspace_dir, 'p')

-- ============================================================
-- Lombok
-- ============================================================

local lombok = vim.fn.stdpath 'config' .. '/external/lombok.jar'

if not vim.uv.fs_stat(lombok) then vim.notify('JDTLS: Lombok jar not found: ' .. lombok, vim.log.levels.WARN) end

-- ============================================================
-- Capabilities
-- ============================================================

local extended_capabilities = jdtls.extendedClientCapabilities

extended_capabilities.resolveAdditionalTextEditsSupport = true

local capabilities = require('blink.cmp').get_lsp_capabilities()

-- ============================================================
-- JDTLS configuration
-- ============================================================

local config = {
  -- IMPORTANT:
  -- jdtls wrapper expects --data
  cmd = {
    'jdtls',
    '--data',
    workspace_dir,
    '--jvm-arg=-javaagent:' .. lombok,
  },

  root_dir = root_dir,

  capabilities = capabilities,

  init_options = {
    extendedClientCapabilities = extended_capabilities,
  },

  -- ==========================================================
  -- Java settings
  -- ==========================================================

  settings = {
    java = {

      -- --------------------------------------------------------
      -- Annotation processing
      -- --------------------------------------------------------

      annotationProcessing = {
        enabled = true,
      },

      -- --------------------------------------------------------
      -- Import
      -- --------------------------------------------------------

      import = {
        maven = {
          enabled = true,
        },

        gradle = {
          enabled = true,

          wrapper = {
            enabled = true,
          },
        },

        nestedProjects = {
          enabled = true,
        },

        exclusions = {
          '**/node_modules/**',
          '**/.metadata/**',
          '**/archetype-resources/**',
          '**/META-INF/maven/**',
        },
      },

      -- --------------------------------------------------------
      -- Build
      -- --------------------------------------------------------

      autobuild = {
        enabled = true,
      },

      -- --------------------------------------------------------
      -- Maven
      -- --------------------------------------------------------

      maven = {
        downloadSources = true,
        updateSnapshots = true,
        finishAutomatically = true,
      },

      -- --------------------------------------------------------
      -- Build configuration
      -- --------------------------------------------------------

      configuration = {
        updateBuildConfiguration = 'interactive',

        runtimes = {},

        maven = {
          userSettings = nil,
          globalSettings = nil,
          defaultMojoExecutionAction = 'execute',
        },
      },

      -- --------------------------------------------------------
      -- JDTLS Android support
      -- --------------------------------------------------------

      jdt = {
        ls = {
          androidSupport = {
            enabled = true,
          },
        },
      },

      -- --------------------------------------------------------
      -- Eclipse
      -- --------------------------------------------------------

      eclipse = {
        downloadSources = true,
        downloadJavadocs = true,
      },

      -- --------------------------------------------------------
      -- Formatter
      -- --------------------------------------------------------

      format = {
        enabled = true,
        useProjectSettings = false,
      },
    },
  },
}

-- ============================================================
-- Start / attach JDTLS
-- ============================================================

jdtls.start_or_attach(config)
