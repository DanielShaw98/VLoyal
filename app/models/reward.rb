class Reward < ApplicationRecord
  belongs_to :card
  has_one_attached :qrcode, dependent: :destroy

  # after_commit :generate_qrcode

  def generate_qrcode
    # Get the host
    host = 'https://vloyal-9cfecae07662.herokuapp.com/'
    reward_id = self.id
    qrcode = RQRCode::QRCode.new("#{host}/rewards/#{reward_id}")
    # Create the PNG object
    png = qrcode.as_png(
        bit_depth: 1,
        border_modules: 4,
        color_mode: ChunkyPNG::COLOR_GRAYSCALE,
        color: "black",
        file: nil,
        fill: "white",
        module_px_size: 6,
        resize_exactly_to: true,
        resize_gte_to: false,
        size: 120,
        offset: 0
      )
    self.qrcode.attach(
        io: StringIO.new(png.to_s),
        filename: "qrcode.png",
        content_type: "image/png"
      )
  end
end
