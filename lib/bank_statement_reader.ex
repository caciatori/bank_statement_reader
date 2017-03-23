defmodule BankStatementReader.Transcation do 
  defstruct TRNTYPE: "", DTPOSTED: "", TRNAMT: "", MEMO: ""
end

defmodule BankStatementReader do
  require Record
  Record.defrecord :xmlElement, Record.extract(:xmlElement, from_lib: "xmerl/include/xmerl.hrl")
  Record.defrecord :xmlText,    Record.extract(:xmlText,    from_lib: "xmerl/include/xmerl.hrl")

  def parse do    
    File.read!('example.ofx')
    |> scan_text
    |> parse_xml
  end

  def scan_text(text) do
    :xmerl_scan.string(String.to_char_list(text))
  end

  def parse_xml({xml, _}) do
    IO.inspect %BankStatementReader.Transcation{
      TRNTYPE:  get_value_tag('TRNTYPE', xml),
      DTPOSTED: get_value_tag('DTPOSTED', xml),
      TRNAMT:   get_value_tag('TRNAMT', xml),        
      MEMO:     get_value_tag('MEMO', xml)        
    }    
  end

  def get_value_tag(name, xml) do
    [ element ] = :xmerl_xpath.string('/OFX/BANKMSGSRSV1/STMTTRNRS/STMTRS/BANKTRANLIST/STMTTRN[1]/#{name}', xml)
    [ text ]    = xmlElement(element, :content)
    value       = xmlText(text, :value)
    
    to_string(value)
  end
end



BankStatementReader.parse()