pub contract Artist {
  
  pub struct Canvas {

    pub let width: UInt8
    pub let height: UInt8
    pub let pixels: String

    init(width: UInt8, height: UInt8, pixels: String) {
      self.width = width
      self.height = height
      self.pixels = pixels      
    }
  }

  pub resource Picture {

    pub let canvas: Canvas

    init(canvas: Canvas) {
      self.canvas = canvas
    }
  }

  pub resource Printer {

    pub let width: UInt8
    pub let height: UInt8
    pub let prints: {String: Canvas}

    init(width: UInt8, height: UInt8) {
      self.width = width
      self.height = height
      self.prints = {}
    }

    pub fun print(canvas: Canvas): @Picture? {
      if(canvas.pixels.length != Int(self.width * self.height)) {
        return nil
      }

      for symbol in canvas.pixels.utf8 {
        if (symbol < 32 || symbol > 126) {
          return nil
        }
      }

      if(!self.prints.containsKey(canvas.pixels)) {
        let picture <- create Picture(canvas: canvas)
        self.prints[canvas.pixels] = canvas        
        return <- picture
      } else {
        return nil
      }
      
    }
  }

  // Quest W1Q3
  pub resource Collection {

    pub let pictures: @[Picture]

    init() {
      self.pictures <- []
    }

    destroy() {
      destroy self.pictures
    }

    pub fun deposit(picture: @Picture) {
      self.pictures.append(<-picture)
    }

    pub fun getCanvases(): [Canvas] {
      var canvases: [Canvas] = []
      var index = 0

      while index < self.pictures.length {
        canvases.append(self.pictures[index].canvas)
        index = index + 1
      }
      return canvases
    }

  }

  pub fun createCollection(): @Collection {
    return <- create Collection()
  }

  init() {
    self.account.save(
      <- create Printer(width: 5, height: 5),
      to: /storage/ArtistPicturePrinter
    )
    self.account.link<&Printer>(
      /public/ArtistPicturePrinter,
      target: /storage/ArtistPicturePrinter
    )    
  }
}
