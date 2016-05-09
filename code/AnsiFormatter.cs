using System;
using System.IO;
using System.Collections;
using System.Collections.Generic;

using ColorCode;
using ColorCode.Common;
using ColorCode.Compilation;
using ColorCode.Compilation.Languages;
using ColorCode.Formatting;
using ColorCode.Parsing;
using ColorCode.Styling.StyleSheets;

namespace RichardSlater {
	public class AnsiFormatter : IFormatter {
		private Dictionary<string, string> styleMap = new Dictionary<string, string> {
			{"Comment", "[32;40m"},
			{"Keyword", "[1;31;40m"},
			{"PowerShell Operator", "[1;37;40m"},
			{"PowerShell Type", "[1;36;40m"},
			{"PowerShell Variable", "[1;33;40m"},
			{"String", "[37;40m"}
		};

		public void Write(string parsedSourceCode,
					  IList<Scope> scopes,
					  IStyleSheet styleSheet,
					  TextWriter textWriter) {
			var styleInsertions = new List<TextInsertion>();

			foreach (Scope scope in scopes)
				GetStyleInsertionsForCapturedStyle(scope, styleInsertions);

			styleInsertions.SortStable((x, y) => x.Index.CompareTo(y.Index));

			int offset = 0;

			foreach (TextInsertion styleInsertion in styleInsertions) {
				textWriter.Write(parsedSourceCode.Substring(offset, styleInsertion.Index - offset));
				if (string.IsNullOrEmpty(styleInsertion.Text)) {
					textWriter.Write((Char)27 + styleMap[styleInsertion.Scope.Name] + styleInsertion.Text);
				}
				else
					textWriter.Write(styleInsertion.Text);
				offset = styleInsertion.Index;
			}

			textWriter.Write(parsedSourceCode.Substring(offset));
		}

		private static void GetStyleInsertionsForCapturedStyle(Scope scope, ICollection<TextInsertion> styleInsertions) {
			styleInsertions.Add(new TextInsertion {
				Index = scope.Index,
				Scope = scope
			});

			foreach (Scope childScope in scope.Children)
				GetStyleInsertionsForCapturedStyle(childScope, styleInsertions);

			styleInsertions.Add(new TextInsertion {
				Index = scope.Index + scope.Length,
				Text = (Char)27 + "[0m" + (Char)27 + "[37;40m"
			});
		}

		public void WriteFooter(IStyleSheet styleSheet, TextWriter textWriter) {}
		public void WriteHeader(IStyleSheet styleSheet, TextWriter textWriter) {}
	}
}