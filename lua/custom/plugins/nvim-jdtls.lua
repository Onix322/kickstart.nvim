local jdtls = require 'jdtls'

local root_dir = vim.fs.root(0, {
  'gradlew',
  'settings.gradle',
  'settings.gradle.kts',
  'pom.xml',
  'mvnw',
  'build.gradle',
  'build.gradle.kts',
})

if not root_dir then return end

local workspace_dir = root_dir .. '/.jdtls'
local lombok = vim.fn.stdpath 'config' .. '/external/lombok.jar'

local capabilities = require('blink.cmp').get_lsp_capabilities()

local android_sdk = vim.env.ANDROID_HOME

if not android_sdk then vim.notify('ANDROID_HOME is not set', vim.log.levels.WARN) end

local android_jar = android_sdk .. '/platforms/android-34/android.jar'

local config = {
  cmd = {
    'jdtls',
    '-data',
    workspace_dir,
    '--jvm-arg=-javaagent:' .. lombok,
  },

  root_dir = root_dir,
  capabilities = capabilities,

  settings = {
    java = {
      project = {
        referencedLibraries = {
          android_jar,
        },
      },
      jdt = {
        ls = {
          androidSupport = {
            enabled = true,
          },
        },
      },

      import = {
        gradle = {
          enabled = true,
          wrapper = {
            enabled = true,
          },
        },

        maven = {
          enabled = true,
        },
      },

      maven = {
        downloadSources = true,
        updateSnapshots = true,
      },

      eclipse = {
        downloadSources = true,
        downloadJavadocs = true,
      },

      configuration = {
        updateBuildConfiguration = 'interactive',
      },

      format = {
        enabled = true,
        useProjectSettings = false,
      },
    },
  },

  init_options = {
    bundles = {},
  },
}

jdtls.start_or_attach(config)
