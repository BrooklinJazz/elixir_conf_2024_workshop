defmodule ChatWeb.Layouts.SwiftUI do
  use ChatNative, [:layout, format: :swiftui]

  embed_templates "layouts_swiftui/*"
end
