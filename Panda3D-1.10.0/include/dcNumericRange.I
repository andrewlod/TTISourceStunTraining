// Filename: dcNumericRange.I
// Created by:  drose (21Jun04)
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
//     Function: DCNumericRange::Constructor
//       Access: Public
//  Description:
////////////////////////////////////////////////////////////////////
template <class NUM>
INLINE DCNumericRange<NUM>::
DCNumericRange() {
}

////////////////////////////////////////////////////////////////////
//     Function: DCNumericRange::Constructor
//       Access: Public
//  Description:
////////////////////////////////////////////////////////////////////
template <class NUM>
INLINE DCNumericRange<NUM>::
DCNumericRange(Number min, Number max) {
  add_range(min, max);
}

////////////////////////////////////////////////////////////////////
//     Function: DCNumericRange::Copy Constructor
//       Access: Public
//  Description:
////////////////////////////////////////////////////////////////////
template <class NUM>
INLINE DCNumericRange<NUM>::
DCNumericRange(const DCNumericRange<NUM> &copy) :
  _ranges(copy._ranges)
{
}

////////////////////////////////////////////////////////////////////
//     Function: DCNumericRange::Copy Assignment Operator
//       Access: Public
//  Description:
////////////////////////////////////////////////////////////////////
template <class NUM>
INLINE void DCNumericRange<NUM>::
operator = (const DCNumericRange<NUM> &copy) {
  _ranges = copy._ranges;
}

////////////////////////////////////////////////////////////////////
//     Function: DCNumericRange::is_in_range
//       Access: Public
//  Description: Returns true if the indicated number is within the
//               specified range, false otherwise.
////////////////////////////////////////////////////////////////////
template <class NUM>
bool DCNumericRange<NUM>::
is_in_range(Number num) const {
  if (_ranges.empty()) {
    return true;
  }

  TYPENAME Ranges::const_iterator ri;
  for (ri = _ranges.begin(); ri != _ranges.end(); ++ri) {
    if (num >= (*ri)._min && num <= (*ri)._max) {
      return true;
    }
  }

  return false;
}

////////////////////////////////////////////////////////////////////
//     Function: DCNumericRange::validate
//       Access: Public
//  Description: Convenience function to validate the indicated
//               number.  If the number is within the specified range,
//               does nothing; otherwise, if it is outside the range,
//               sets range_error to true.
////////////////////////////////////////////////////////////////////
template <class NUM>
INLINE void DCNumericRange<NUM>::
validate(Number num, bool &range_error) const {
  if (!is_in_range(num)) {
    range_error = true;
  }
}

////////////////////////////////////////////////////////////////////
//     Function: DCNumericRange::has_one_value
//       Access: Public
//  Description: Returns true if the numeric range specifies exactly
//               one legal value, false if multiple values are legal.
////////////////////////////////////////////////////////////////////
template <class NUM>
INLINE bool DCNumericRange<NUM>::
has_one_value() const {
  return _ranges.size() == 1 && _ranges[0]._min == _ranges[0]._max;
}

////////////////////////////////////////////////////////////////////
//     Function: DCNumericRange::get_one_value
//       Access: Public
//  Description: If has_one_value() returns true, this returns the one
//               legal value accepted by the numeric range.
////////////////////////////////////////////////////////////////////
template <class NUM>
INLINE TYPENAME DCNumericRange<NUM>::Number DCNumericRange<NUM>::
get_one_value() const {
  nassertr(has_one_value(), 0);
  return _ranges[0]._min;
}

////////////////////////////////////////////////////////////////////
//     Function: DCNumericRange::generate_hash
//       Access: Public
//  Description: 
////////////////////////////////////////////////////////////////////
template <class NUM>
void DCNumericRange<NUM>::
generate_hash(HashGenerator &hashgen) const {
  if (!_ranges.empty()) {
    hashgen.add_int(_ranges.size());
    TYPENAME Ranges::const_iterator ri;
    for (ri = _ranges.begin(); ri != _ranges.end(); ++ri) {
      // We don't account for the fractional part of floating-point
      // ranges here.  Shouldn't be a real issue.
      hashgen.add_int((int)(*ri)._min);
      hashgen.add_int((int)(*ri)._max);
    }
  }
}

////////////////////////////////////////////////////////////////////
//     Function: DCNumericRange::output
//       Access: Public
//  Description: 
////////////////////////////////////////////////////////////////////
template <class NUM>
void DCNumericRange<NUM>::
output(ostream &out, Number divisor) const {
  if (!_ranges.empty()) {
    TYPENAME Ranges::const_iterator ri;
    ri = _ranges.begin();
    output_minmax(out, divisor, *ri);
    ++ri;
    while (ri != _ranges.end()) {
      out << ", ";
      output_minmax(out, divisor, *ri);
      ++ri;
    }
  }
}

////////////////////////////////////////////////////////////////////
//     Function: DCNumericRange::output_char
//       Access: Public
//  Description: Outputs the range, formatting the numeric values as
//               quoted ASCII characters.
////////////////////////////////////////////////////////////////////
template <class NUM>
void DCNumericRange<NUM>::
output_char(ostream &out, Number divisor) const {
  if (divisor != 1) {
    output(out, divisor);

  } else {
    if (!_ranges.empty()) {
      TYPENAME Ranges::const_iterator ri;
      ri = _ranges.begin();
      output_minmax_char(out, *ri);
      ++ri;
      while (ri != _ranges.end()) {
        out << ", ";
        output_minmax_char(out, *ri);
        ++ri;
      }
    }
  }
}

////////////////////////////////////////////////////////////////////
//     Function: DCNumericRange::clear
//       Access: Public
//  Description: 
////////////////////////////////////////////////////////////////////
template <class NUM>
INLINE void DCNumericRange<NUM>::
clear() {
  _ranges.clear();
}

////////////////////////////////////////////////////////////////////
//     Function: DCNumericRange::add_range
//       Access: Public
//  Description: Adds a new minmax to the list of ranges.  This is
//               normally called only during dc file parsing.  Returns
//               true if successful, or false if the new minmax
//               overlaps an existing minmax.
////////////////////////////////////////////////////////////////////
template <class NUM>
bool DCNumericRange<NUM>::
add_range(Number min, Number max) {
  // Check for an overlap.  This is probably indicative of a typo and
  // should be reported.
  if (max < min) {
    return false;
  }

  TYPENAME Ranges::const_iterator ri;
  for (ri = _ranges.begin(); ri != _ranges.end(); ++ri) {
    if ((min >= (*ri)._min && min <= (*ri)._max) ||
        (max >= (*ri)._min && max <= (*ri)._max) ||
        (min < (*ri)._min && max > (*ri)._max)) {
      return false;
    }
  }

  MinMax minmax;
  minmax._min = min;
  minmax._max = max;
  _ranges.push_back(minmax);

  return true;
}

////////////////////////////////////////////////////////////////////
//     Function: DCNumericRange::is_empty
//       Access: Private
//  Description: Returns true if the range contains no elements (and
//               thus allows all numbers), false if it contains at
//               least one.
////////////////////////////////////////////////////////////////////
template <class NUM>
INLINE bool DCNumericRange<NUM>::
is_empty() const {
  return _ranges.empty();
}

////////////////////////////////////////////////////////////////////
//     Function: DCNumericRange::get_num_ranges
//       Access: Private
//  Description: Returns the number of minmax components in the range
//               description.
////////////////////////////////////////////////////////////////////
template <class NUM>
INLINE int DCNumericRange<NUM>::
get_num_ranges() const {
  return _ranges.size();
}

////////////////////////////////////////////////////////////////////
//     Function: DCNumericRange::get_min
//       Access: Private
//  Description: Returns the minimum value defined by the nth component.
////////////////////////////////////////////////////////////////////
template <class NUM>
INLINE TYPENAME DCNumericRange<NUM>::Number DCNumericRange<NUM>::
get_min(int n) const {
  nassertr(n >= 0 && n < (int)_ranges.size(), 0);
  return _ranges[n]._min;
}

////////////////////////////////////////////////////////////////////
//     Function: DCNumericRange::get_max
//       Access: Private
//  Description: Returns the maximum value defined by the nth component.
////////////////////////////////////////////////////////////////////
template <class NUM>
INLINE TYPENAME DCNumericRange<NUM>::Number DCNumericRange<NUM>::
get_max(int n) const {
  nassertr(n >= 0 && n < (int)_ranges.size(), 0);
  return _ranges[n]._max;
}

////////////////////////////////////////////////////////////////////
//     Function: DCNumericRange::output_minmax
//       Access: Private
//  Description: Outputs a single element of the range description.
////////////////////////////////////////////////////////////////////
template <class NUM>
INLINE void DCNumericRange<NUM>::
output_minmax(ostream &out, Number divisor, const MinMax &range) const {
  if (divisor == 1) {
    if (range._min == range._max) {
      out << range._min;
    } else {
      out << range._min << "-" << range._max;
    }
  } else {
    if (range._min == range._max) {
      out << (double)range._min / (double)divisor;
    } else {
      out << (double)range._min / (double)divisor
          << "-"
          << (double)range._max / (double)divisor;
    }
  }
}

////////////////////////////////////////////////////////////////////
//     Function: DCNumericRange::output_minmax_char
//       Access: Private
//  Description: Outputs a single element of the range description.
////////////////////////////////////////////////////////////////////
template <class NUM>
INLINE void DCNumericRange<NUM>::
output_minmax_char(ostream &out, const MinMax &range) const {
  if (range._min == range._max) {
    DCPacker::enquote_string(out, '\'', string(1, range._min));
  } else {
    DCPacker::enquote_string(out, '\'', string(1, range._min));
    out << "-";
    DCPacker::enquote_string(out, '\'', string(1, range._max));
  }
}
