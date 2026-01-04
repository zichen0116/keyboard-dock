// Called by AHK to sync UI state
window.setState = function (state) {
  if (!state) return;
  var dock = document.getElementById('dock');
  var panel = document.getElementById('panel');

  if (state.collapsed === true) {
    dock.className = 'dock collapsed';
  } else if (state.collapsed === false) {
    dock.className = 'dock';
  }
  if (state.blocked === true) {
    panel.className = 'panel blocked';
  } else if (state.blocked === false) {
    panel.className = 'panel';
  }
};
