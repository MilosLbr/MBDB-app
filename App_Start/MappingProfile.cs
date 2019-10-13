using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using AutoMapper;
using MBDBapp.Models;
using MBDBapp.Models.Dto;

namespace MBDBapp.App_Start
{
    public class MappingProfile : Profile
    {
        public MappingProfile()
        {
            // Film
            Mapper.CreateMap<Film, FilmDto>().IgnoreAllNonExisting()
                .ForMember(dto => dto.Director, f => f.MapFrom(prop => prop.tblDirector))
                .ForMember(dto => dto.CastMembers, f => f.MapFrom(prop => prop.tblCasts))
                .ForMember(dto => dto.Studio, f => f.MapFrom(prop => prop.tblStudio));

            Mapper.CreateMap<FilmDto, Film>()
                .ForMember(f => f.FilmID, opt => opt.Ignore());

            // Director
            Mapper.CreateMap<Director, DirectorDto>();
            Mapper.CreateMap<DirectorDto, Director>();

            // Cast
            Mapper.CreateMap<Cast, CastDto>()
                .ForMember(dto => dto.Actor, cs => cs.MapFrom(prop => prop.tblActor));
            Mapper.CreateMap<CastDto, Cast>();

            // Actor
            Mapper.CreateMap<Actor, ActorDto>();
            Mapper.CreateMap<ActorDto, Actor>();

            // Stduio
            Mapper.CreateMap<Studio, StudioDto>();
            Mapper.CreateMap<StudioDto, Studio>();
        }

        
    }

    public static class ExtensionMethod
    {
        public static IMappingExpression<TSource, TDestination> IgnoreAllNonExisting<TSource, TDestination>(this IMappingExpression<TSource, TDestination> expression)
        {
            var flags = System.Reflection.BindingFlags.Public | System.Reflection.BindingFlags.Instance;
            var sourceType = typeof(TSource);
            var destinationProperties = typeof(TDestination).GetProperties(flags);

            foreach (var property in destinationProperties)
            {
                if (sourceType.GetProperty(property.Name, flags) == null)
                {
                    expression.ForMember(property.Name, opt => opt.Ignore());
                }
            }
            return expression;
        }
    }
}