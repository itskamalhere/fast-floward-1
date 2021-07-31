import Artist from 0x01

pub fun main() {

  let accounts = [
    getAccount(0x01),
    getAccount(0x02),
    getAccount(0x03),
    getAccount(0x04),
    getAccount(0x05)
  ]

  for account in accounts {
    let collectionRef = account
      .getCapability(/public/ArtistPictureCollection)
      .borrow<&Artist.Collection>()
    
    if collectionRef == nil {
      log("Account ".concat(account.address.toString()).concat(" doesn't have a Collection"))
    } else {
        log("Account ".concat(account.address.toString()).concat(" Pictures"))
        var pictureNumber = 1
        for canvas in collectionRef!.getCanvases() {
        log("Picture #".concat(pictureNumber.toString()))
            display(canvas: canvas)
            pictureNumber = pictureNumber + 1
        }
    }    
  }
}

pub fun display(canvas: Artist.Canvas) {
    let canvasWidth = Int(canvas.width)
    let canvasHeight = Int(canvas.height)
    if(canvas.pixels.length == canvasWidth * canvasHeight) {
        var row = 0
        drawBorder(width: canvasWidth)
        while row < canvasHeight {
            let startPos = row * canvasWidth
            let endPos = row * canvasWidth + canvasWidth
            log("|".concat(canvas.pixels.slice(from: startPos, upTo: endPos)).concat("|"))
            row = row + 1
        }
        drawBorder(width: canvasWidth)        
    } else {
        log("Canvas size and pixels length does not match!!")
    }
}

pub fun drawBorder(width: Int) {
    var column = 0;
    var border = "+"    
    while column < width {
        border = border.concat("-")
        column = column + 1
    }
    border = border.concat("+")
    log(border)
}
