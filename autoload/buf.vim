vim9script

def s:lspDiagSevToSignName(severity: number): string
  var typeMap: list<string> = ['LspDiagError', 'LspDiagWarning',
						'LspDiagInfo', 'LspDiagHint']
  if severity > 4
    return 'LspDiagHint'
  endif
  return typeMap[severity - 1]
enddef

# New LSP diagnostic messages received from the server for a file.
# Update the signs placed in the buffer for this file
export def LspDiagsUpdated(lspserver: dict<any>, bnr: number)
  if bnr == -1 || !lspserver.diagsMap->has_key(bnr)
    return
  endif

  # Remove all the existing diagnostic signs
  sign_unplace('LSPDiag', {buffer: bnr})

  if lspserver.diagsMap[bnr]->empty()
    return
  endif

  var signs: list<dict<any>> = []
  for [lnum, diag] in items(lspserver.diagsMap[bnr])
    signs->add({id: 0, buffer: str2nr(bnr), group: 'LSPDiag',
				lnum: str2nr(lnum),
				name: s:lspDiagSevToSignName(diag.severity)})
  endfor

  signs->sign_placelist()
enddef

# vim: shiftwidth=2 softtabstop=2