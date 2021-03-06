import Artist from 0x01

transaction {

    let printerRef: &Artist.Printer
    let collectionRef: &Artist.Collection

    prepare(account: AuthAccount) {

        account.save(
            <- Artist.createCollection(),
            to: /storage/ArtistPictureCollection
        )

        account.link<&Artist.Collection>(
            /public/ArtistPictureCollection,
            target: /storage/ArtistPictureCollection
        )        
        
        self.collectionRef = account
            .borrow<&Artist.Collection>(from: /storage/ArtistPictureCollection)
            ?? panic("Couldn't borrow collection reference")
            
        self.printerRef = getAccount(0x04)
            .getCapability<&Artist.Printer>(/public/ArtistPicturePrinter)
            .borrow()
            ?? panic("Couldn't borrow printer reference")
    }

    execute {
        let pixels = "*   *   *   *   * *     *"
        let canvas = Artist.Canvas(
            width: self.printerRef.width,
            height: self.printerRef.height,
            pixels
        )    
        let picture <- self.printerRef.print(canvas: canvas)
        if(picture == nil) {
            log("Picture with ".concat(pixels).concat(" already exists!"))
            destroy picture
        } else {
            log("Picture printed!")
            self.collectionRef.deposit(picture: <-picture!)
        }
    }
}
