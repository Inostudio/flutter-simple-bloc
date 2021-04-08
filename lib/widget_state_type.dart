enum WidgetStateType {
  /// Mean State created but context is BuildContext in progress of init
  initializing,
  /// Mean BuildContext is initialized and State mounted to ViewTree
  visible,
  /// Mean current State is moved back in History and didn't visible in foreground
  invisible,
  /// Mean state ready to destroy
  destroying,
}
