// Filename: sceneGraphAnalyzerMeter.I
// Created by:  pratt (14Feb07)
//
////////////////////////////////////////////////////////////////////
//
// PANDA 3D SOFTWARE
// Copyright (c) Carnegie Mellon University.  All rights reserved.
//
// All use of this software is subject to the terms of the revised BSD
// license.  You should have received a copy of this license along
// with this source code in a file named "LICENSE."
//
////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////
//     Function: SceneGraphAnalyzerMeter::get_window
//       Access: Published
//  Description: Returns the GraphicsOutput that was passed to
//               setup_window(), or NULL if setup_window() has not
//               been called.
////////////////////////////////////////////////////////////////////
INLINE GraphicsOutput *SceneGraphAnalyzerMeter::
get_window() const {
  return _window;
}

////////////////////////////////////////////////////////////////////
//     Function: SceneGraphAnalyzerMeter::get_display_region
//       Access: Published
//  Description: Returns the DisplayRegion that the meter has created
//               to render itself into the window to setup_window(),
//               or NULL if setup_window() has not been called.
////////////////////////////////////////////////////////////////////
INLINE DisplayRegion *SceneGraphAnalyzerMeter::
get_display_region() const {
  return _display_region;
}

////////////////////////////////////////////////////////////////////
//     Function: SceneGraphAnalyzerMeter::set_update_interval
//       Access: Published
//  Description: Specifies the number of seconds that should elapse
//               between updates to the meter.  This should be
//               reasonably slow (e.g. 0.5 to 2.0) so that the
//               calculation of the scene graph analysis does not
//               itself dominate the frame rate.
////////////////////////////////////////////////////////////////////
INLINE void SceneGraphAnalyzerMeter::
set_update_interval(double update_interval) {
  _update_interval = update_interval;
}

////////////////////////////////////////////////////////////////////
//     Function: SceneGraphAnalyzerMeter::get_update_interval
//       Access: Published
//  Description: Returns the number of seconds that will elapse
//               between updates to the frame rate indication.
////////////////////////////////////////////////////////////////////
INLINE double SceneGraphAnalyzerMeter::
get_update_interval() const {
  return _update_interval;
}

////////////////////////////////////////////////////////////////////
//     Function: SceneGraphAnalyzerMeter::set_node
//       Access: Published
//  Description: Sets the node to be analyzed.
////////////////////////////////////////////////////////////////////
INLINE void SceneGraphAnalyzerMeter::
set_node(PandaNode *node) {
  _node = node;
}

////////////////////////////////////////////////////////////////////
//     Function: SceneGraphAnalyzerMeter::get_node
//       Access: Published
//  Description: Returns the node to be analyzed.
////////////////////////////////////////////////////////////////////
INLINE PandaNode *SceneGraphAnalyzerMeter::
get_node() const {
  return _node;
}

////////////////////////////////////////////////////////////////////
//     Function: SceneGraphAnalyzerMeter::update
//       Access: Published
//  Description: You can call this to explicitly force the
//               SceneGraphAnalyzerMeter to update itself with the
//               latest scene graph analysis information.
//               Normally, it is not necessary to call this explicitly.
////////////////////////////////////////////////////////////////////
INLINE void SceneGraphAnalyzerMeter::
update() {
  Thread *current_thread = Thread::get_current_thread();
  do_update(current_thread);
}
