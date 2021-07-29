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

pub fun serializeStringArray(_ lines: [String]): String {
    var buffer = ""
    for line in lines {
        buffer = buffer.concat(line)
    }

    return buffer
}

//W1Q1--------------------Start
pub fun display(canvas: Canvas) {
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
//W1Q1--------------------End

//W1Q2--------------------Start
pub resource Printer {

    pub let collection: Collection

    init() {
        self.collection = Collection()
    }

    pub fun print(canvas: Canvas): @Picture? {        
        if(self.collection.addToGallery(pixels: canvas.pixels)) {
            let picture <- create Picture(canvas: canvas)
            log("Printing...")
            display(canvas: picture.canvas)
            return <-picture
        } else {
            log("Printing failed, Picture already exists!!")
            return nil
        }
    }
}

pub struct Collection {

    pub let gallery: [String]
    
    init() {
        self.gallery = []
    }

    pub fun addToGallery(pixels: String): Bool {
        var added: Bool = false
        if(self.isUnique(pixels)) {
            self.gallery.append(pixels)
            added = true
        }
        return added
    }

    pub fun isUnique(_ pixels: String): Bool{
        return !self.gallery.contains(pixels)
    }
}
//W1Q2--------------------End

pub fun main() {    
    let pixelsX = [
        "*   *",
        " * * ",
        "  *  ",
        " * * ",
        "*   *"
    ]
    
    let canvasX = Canvas(width: 5, height: 5, pixels: serializeStringArray(pixelsX))
    let printer <- create Printer()
    let letterX <- printer.print(canvas: canvasX)
    let letterY <- printer.print(canvas: canvasX)
    let letterZ <- printer.print(canvas: canvasX)
    
    destroy letterX
    destroy letterY
    destroy letterZ
    destroy printer
}