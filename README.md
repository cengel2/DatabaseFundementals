# **DMIT-1508 DatabaseFundementals**
# [***Curtis Engel-Class Notes***](//github.com/cengel2/DatabaseFundementals/blob/master/ClassNotes.MD)
# [**Learning Outcome Guides**](http://dmit-1508.github.io/learningOutcomeGuides)
# [**Supplemental Learning Notes**](http://dmit1508.funs-tuff.com)

# Number 5 on Lab3  - is this overkill
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE = N'PROCEDURE' AND ROUTINE_NAME = 'UpdateTitle')
    DROP PROCEDURE UpdateTitle
GO
CREATE PROCEDURE UpdateTitle
   @isbn char(10),
   @title varchar(30),
   @catcode int,
   @publishercode int,
   @suggestedprice money,
   @numberinstock int
AS
    IF (@isbn IS NULL OR @title IS NULL OR @catcode IS NULL OR @publishercode IS NULL OR @suggestedprice IS NULL OR @numberinstock IS NULL)
	BEGIN
		RAISERROR('Must provide all attributes associated with Title', 16, 2) 
	END
	ELSE
	BEGIN
		IF NOT EXISTS (SELECT ISBN FROM Books WHERE ISBN = @isbn)
		BEGIN
			RAISERROR('Update failed. ISBN does not exist',16,2)
			RETURN
		END
		ELSE
		BEGIN
			IF (@publishercode < 200 OR @publishercode >208 OR @catcode < 1 OR @catcode > 8)
			BEGIN
				RAISERROR('The Category and/or Publisher Codes are not valid', 16, 2)
				RETURN
			END
		END
		BEGIN TRANSACTION
		UPDATE Books
		SET Title = @title
		WHERE ISBN =  @isbn	
			IF (@@ERROR <> 0)
			BEGIN
				RAISERROR('Title update failed', 16, 2)
				ROLLBACK TRANSACTION
			END
		ELSE
		BEGIN
			Update Books
			SET CategoryCode = @catcode
			WHERE ISBN =  @isbn	
		END
			IF (@@ERROR <> 0)
			BEGIN
				RAISERROR('Category Code update failed', 16, 2)
				ROLLBACK TRANSACTION
			END
		ELSE
		BEGIN
			Update Books
			SET PublisherCode = @publishercode
			WHERE ISBN =  @isbn		
		END
			IF (@@ERROR <> 0)
			BEGIN
				RAISERROR('Publisher Code update failed', 16, 2)
				ROLLBACK TRANSACTION
			END
		ELSE
		BEGIN
			Update Books
			SET SuggestedPrice = @suggestedprice
			WHERE ISBN =  @isbn		
		END
			IF (@@ERROR <> 0)
			BEGIN
				RAISERROR('Suggested Price update failed', 16, 2)
				ROLLBACK TRANSACTION
			END
		ELSE
		BEGIN
			Update Books
			SET NumberInStock = @numberinstock
			WHERE ISBN =  @isbn		
		END
			IF (@@ERROR <> 0)
			BEGIN
				RAISERROR('NumberInStock update failed', 16, 2)
				ROLLBACK TRANSACTION
			END
		ELSE
		BEGIN
			COMMIT TRANSACTION
		END			
	END
RETURN
GO
