import Artist from "./contract.cdc"

// Print a Picture and store it in the authorizing account's Picture Collection.
transaction(width: UInt8, height: UInt8, pixels: String) {

    let printerRef: &Artist.Printer
    let collectionRef: &Artist.Collection

    prepare(account: AuthAccount) {
        self.printerRef = getAccount(0x01cf0e2f2f715450)
            .getCapability(/public/ArtistPicturePrinter)
            .borrow<&Artist.Printer>()
            ?? panic("Couldn't borrow printer reference")
        
        self.collectionRef = getAccount(0x01cf0e2f2f715450)
            .getCapability(/public/ArtistPictureCollection)
            .borrow<&Artist.Collection>()
            ?? panic("Couldn't borrow collection reference")
    }

    execute {
        //let pixels = "*   *   *   *   * *     *"
        let canvas = Artist.Canvas(
            width: width,
            height: height,
            pixels: pixels
        )    
        let picture <- self.printerRef.print(width: 5, height: 5, canvas: canvas)
        if(picture == nil) {
            log("Picture with ".concat(pixels).concat(" already exists!"))
            destroy picture
        } else {
            log("Picture printed!")
            self.collectionRef.deposit(picture: <-picture!)
        }
    }
}