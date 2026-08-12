
using System.Text.Json;
using System.Text.Json.Serialization;
using System.ComponentModel.DataAnnotations.Schema;
using NetTopologySuite.Geometries;
using NetTopologySuite.IO;
using Newtonsoft.Json;

namespace ParklaysBackend.Models
{
    [Table("parkinglots")]
    public class ParkingLot
    {
        [Column("id")]
        public int Id { get; set; }

        [Column("name")]
        public string Name { get; set; } = string.Empty;

        [Column("location")]
        public string Location { get; set; } = string.Empty;

        [Column("capacity")]
        public int Capacity { get; set; }

        [Newtonsoft.Json.JsonIgnore]
        [Column("geom")]
        public Geometry? Geom { get; set; }
        
        [NotMapped]
public string? GeoJson
{
    get
    {
        if (Geom == null) return null;
        var writer = new GeoJsonWriter();
        return writer.Write(Geom);
    }
}
    }
}


