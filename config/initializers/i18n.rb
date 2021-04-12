I18n::Backend::Simple.send(:include, I18n::Backend::Fallbacks)

I18n.available_locales = [:en,  :fi, :sv, :ru]
I18n.default_locale = :en
I18n.fallbacks[:en] = [:en,  :fi, :ru, :sv]
I18n.fallbacks[:fi] = [:fi,  :en,  :ru, :sv]
I18n.fallbacks[:sv] = [:sv, :fi, :en, :ru]
I18n.fallbacks[:ru] = [:ru, :fi, :en, :sv]

Globalize.fallbacks = { en: [:en, :fi, :ru, :sv], fi: [:fi, :en, :ru, :sv], sv: [:sv, :fi, :en, :ru], ru: [:ru, :fi, :en, :sv] }
I18n.enforce_available_locales = false