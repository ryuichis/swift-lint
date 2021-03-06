/*
   Copyright 2017 Ryuichi Laboratories and the Yanagiba project contributors

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*/

import Foundation

import Source

class HTMLReporter : Reporter {
  func handle(issues: [Issue]) -> String {
    if issues.isEmpty {
      return ""
    }

    var issuesText = """
    <hr />
    <table>
      <thead>
        <tr>
          <th>File</th>
          <th>Location</th>
          <th>Rule Identifier</th>
          <th>Rule Category</th>
          <th>Severity</th>
          <th>Message</th>
        </tr>
      </thead>
      <tbody>
    """

    issuesText += issues.map({ $0.htmlString }).joined(separator: separator)

    issuesText += "</tbody></table>"

    return issuesText
  }

  func handle(numberOfTotalFiles: Int, issueSummary: IssueSummary) -> String {
    let numberOfIssueFiles = issueSummary.numberOfFiles
    var summaryHtml = """
    <table>
      <thead>
        <tr>
          <th>Total Files</th>
          <th>Files with Issues</th>
    """
    summaryHtml += Issue.Severity.allSeverities
      .map({ "<th>\($0.rawValue.capitalized)</th>" }).joined(separator: "\n")
    summaryHtml += """
        </tr>
      </thead>
      <tbody>
        <tr>
          <td>\(numberOfTotalFiles)</td>
          <td>\(numberOfIssueFiles)</td>
    """
    summaryHtml += Issue.Severity.allSeverities.map({
      let count = issueSummary.numberOfIssues(withSeverity: $0)
      return "<th class=\"severity-\($0)\">\(count)</th>"
    }).joined(separator: "\n")
    summaryHtml += """
        </tr>
      </tbody>
    </table>
    """
    return summaryHtml
  }

  var header: String {
    return """
    <!DOCTYPE html>
    <html>
    <head>
    <title>Yanagiba's swift-lint Report</title>
    <style type='text/css'>
    .severity-critical, .severity-major, .severity-minor, .severity-cosmetic {
      font-weight: bold;
      text-align: center;
      color: #BF0A30;
    }
    .severity-critical { background-color: #FFC200; }
    .severity-major { background-color: #FFD3A6; }
    .severity-minor { background-color: #FFEEB5; }
    .severity-cosmetic { background-color: #FFAAB5; }
    table {
      border: 2px solid gray;
      border-collapse: collapse;
      -moz-box-shadow: 3px 3px 4px #AAA;
      -webkit-box-shadow: 3px 3px 4px #AAA;
      box-shadow: 3px 3px 4px #AAA;
    }
    td, th {
      border: 1px solid #D3D3D3;
      padding: 4px 20px 4px 20px;
    }
    th {
      text-shadow: 2px 2px 2px white;
      border-bottom: 1px solid gray;
      background-color: #E9F4FF;
    }
    </style>
    </head>
    <body>
    <h1>Yanagiba's swift-lint report</h1>
    <hr />
    """
  }

  var footer: String {
    let versionInfo = "Yanagiba's \(SWIFT_LINT) v\(SWIFT_LINT_VERSION)"
    return """
    <hr />
    <p>
      \(Date().formatted)
      |
      Generated with <a href='http://yanagiba.org/swift-lint'>\(versionInfo)</a>.
    </p>
    </body>
    </html>
    """
  }
}
