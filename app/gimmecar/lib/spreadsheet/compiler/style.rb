class Lib::Spreadsheet::Compiler::Style

  DEFAULT_SIZE         = 12
  DEFAULT              = { sz: DEFAULT_SIZE, alignment: { vertical: :center, wrap_text: true }}

  FONT_LARGE           = { sz: 16 }

  BOLD                 = { b: true }

  HEAD                 = { bg_color: 'efefef' }
  HEAD_TITLE           = { sz: 14 }.merge(BOLD).merge(HEAD)
  HEAD_DESCRIPTION     = { sz: 11, fg_color: 'a0a0a0' }.merge(HEAD)
  HEAD_HEADER          = { sz: DEFAULT_SIZE, alignment: {vertical: :center, wrap_text: true}, border: { style: :medium, color: '888888', edges: [:bottom] }, bg_color: 'efefef' }.merge(BOLD)

  HEADER               = { bg_color: 'eef0f5' }.merge(DEFAULT)
  HEADER_BORDER        = { border: { style: :medium, color: '666666', edges: [:bottom] } }

  SUB_HEADER           = { bg_color: 'f2f6fa' }.merge(DEFAULT)
  SUB_HEADER_BORDER    = { border: { style: :thin, color: 'aaaaaa', edges: [:bottom] } }

  TOTAL                = { bg_color: 'eef0f5' }.merge(DEFAULT)
  TOTAL_BORDER         = { border: { style: :medium, color: '666666', edges: [:top] } }

  SUB_TOTAL            = { bg_color: 'f2f6fa' }.merge(DEFAULT)
  SUB_TOTAL_BORDER     = { border: { style: :thin, color: 'aaaaaa', edges: [:top] } }

  GENERAL              = { num_fmt: 0 }
  CURRENCY             = { format_code: "$#,##0.00" }
  DATE                 = { format_code: 'mm/dd/yyyy'}
  PRICE_PER_SHARE      = { format_code: "$#,##0.0000" }
  SHARES               = { num_fmt: 3 }
  PERCENT              = { num_fmt: 10 }
  FOUR_DECIMAL_NUMBER  = { format_code: "0.0000" }
  FOUR_DECIMAL_PERCENT = { format_code: "0.0000%" }
  TWO_DECIMAL_RATIO    = { format_code: "0.00x" }

  INDENT_SMALL         = { alignment: { indent: 2, vertical: :center } }
  BORDER_BOTTOM_LIGHT  = { border: { style: :thin, color: "dfdfdf", edges: [:bottom] } }

  ALIGN_RIGHT          = { alignment: { horizontal: :right } }
  ALIGN_LEFT           = { alignment: { horizontal: :left } }

  class << self
    def parse(names)
      styles = {}
      names = [names] unless names.is_a?(Array)
      names.each { |name| styles.deep_merge!(const_get(name.to_s.upcase)) }
      styles
    end
  end
end
