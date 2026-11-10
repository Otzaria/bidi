## Unreleased (Otzaria fork)

* Faster ASCII-only and unpointed Hebrew paragraph processing.
* Linear-time bidi-formatting-marker filtering and fewer transient allocations.
* Handle supplementary Unicode scalar values and keep UTF-16 source offsets.
* Preserve Hebrew combining marks after visual reordering.
* Correct global source indices and source lengths from `logicalToVisual2`.
* Preserve Arabic lam-alef ligature source spans, including transparent marks.
* Resolve paired brackets using Unicode BidiBrackets metadata, including recent brackets.
* Expand regression tests and independent reference vectors for mixed Hebrew,
  Latin, digits, punctuation, and source indices.

These changes are not part of the published 2.0.13 package. Full support for
modern Unicode isolates is still pending.

## 2.0.13

* Improve package score.

## 2.0.12

* Improve package score.

## 2.0.10

* Improve package score.

## 2.0.8

* Performance improvement.
* Preparing for version 3.0.

## 2.0.7

* Dart SDK 3.0 support.

## 2.0.6

* Deprecate `paragraphSeparator` in favor of `separator`.

## 2.0.5

* Make `paragraphSeparator` public.

## 2.0.4

* Pass static analysis.

## 2.0.3

* More dartdoc comments.

## 2.0.2

* Fix Arabic Shadda pairs are not composed (#4). Thanks to Milad Akarie.

## 2.0.1

* Fixes a composition bug. Thanks to Milad Akarie for reporting.

## 2.0.0

* Migrated to null-safety.

## 1.0.0

* First working version of Bidi.
